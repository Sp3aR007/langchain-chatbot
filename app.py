# from flask import Flask, render_template, jsonify, request
from src.helper import download_huggingface_embeddings
from langchain_pinecone import PineconeVectorStore
from langchain_google_genai import ChatGoogleGenerativeAI   
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_core.prompts import ChatPromptTemplate
from dotenv import load_dotenv
from src.prompt import *
import os
import gradio as gr
import time
from langchain.memory import ConversationBufferMemory


load_dotenv()

PINECONE_API_KEY=os.environ.get('PINECONE_API_KEY')
GOOGLE_API_KEY=os.environ.get('GOOGLE_API_KEY')

os.environ["PINECONE_API_KEY"] = PINECONE_API_KEY
os.environ["GOOGLE_API_KEY"] = GOOGLE_API_KEY

embeddings = download_huggingface_embeddings()

index_name = "chatbot"

docsearch = PineconeVectorStore.from_existing_index(
    index_name=index_name,
    embedding=embeddings
)

retriever = docsearch.as_retriever(search_type="similarity", search_kwargs={"k":3})


llm = ChatGoogleGenerativeAI(model="gemini-1.5-pro",temperature=0,max_tokens=None,timeout=None)
prompt = ChatPromptTemplate.from_messages(
    [
        ("system", system_prompt),
        ("human", "{input}"),
    ]
)

question_answer_chain = create_stuff_documents_chain(llm, prompt)
rag_chain = create_retrieval_chain(retriever, question_answer_chain)

# Define RAG function for ChatInterface
def rag_chat(message, history):
    chat_history = []
    # Ensure history is correctly formatted before processing
    if isinstance(history, list):  # Check if history is a list
        for entry in history:
            if isinstance(entry, list) and len(entry) == 2:  # Ensure correct structure
                user_msg, bot_msg = entry
                chat_history.append({"role": "user", "content": user_msg})
                chat_history.append({"role": "model", "content": bot_msg})
    # Append latest user message
    chat_history.append({"role": "user", "content": message})
    """Processes user message using RAG pipeline."""
    response = rag_chain.invoke({"input": message, "chat_history": chat_history})
    return response["answer"]
demo=gr.ChatInterface(
        fn = rag_chat,
        type="messages",
        title="Chat-Bot",
        description="Chat bot application created using Retreival-Augmented Generation",
        flagging_mode="manual",
        flagging_options=["Like", "Spam", "Inappropriate", "Other"],
        save_history=True
    )


# @app.route("/")
# def index():
#     return render_template('chat.html')


# @app.route("/get", methods=["GET", "POST"])
# def chat():
#     msg = request.form["msg"]
#     input = msg
#     print(input)
#     response = rag_chain.invoke({"input": msg})
#     print("Response : ", response["answer"])
#     return str(response["answer"])


if __name__ == '__main__':
    demo.launch(server_name="0.0.0.0", server_port=7860)
    # app.run(host="0.0.0.0", port= 8080, debug= True)
