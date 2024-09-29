import os
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ValidationError
from uuid import uuid4
from Books import Book, UpdateBook
from azure.cosmos import CosmosClient
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allow all methods
    allow_headers=["*"],  # Allow all headers
)

# Get Cosmos DB client
load_dotenv()
COSMOS_ENDPOINT = os.getenv("COSMOS_ENDPOINT")

credential = DefaultAzureCredential()
client = CosmosClient(url=COSMOS_ENDPOINT, credential=credential)
database = client.get_database_client("mydb")
container = database.get_container_client("books")

@app.post("/api/books")
async def createBook(book: Book):
    """
    Creates a new book entry in the database from the HTTP request data.

    This function is triggered by an HTTP POST request. It expects a JSON payload
    with the book's details, validates the data using the Book model, and then
    saves the new book document to Cosmos DB. If the data is invalid or the request
    cannot be processed, it returns an appropriate HTTP response.

    Args:
        book (Book): The HTTP request object containing the Book data.

    Returns:
        dict: The created book document if successful.
        Raises HTTPException with status code 400 if the request data is invalid or not in JSON format.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Save the new book to the database
        container.create_item(body=book.model_dump())
        return book
    except ValidationError as ve:
        raise HTTPException(status_code=400, detail="Invalid input data")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.get("/api/books")
async def getBooks():
    """
    Retrieves all book entries from the database.

    This function is triggered by an HTTP GET request. It retrieves all book
    documents from the Cosmos DB container and returns them as a list. If there
    are no books in the database, it returns an empty list.

    Returns:
        list: A list of book documents.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Query all books from the database
        query = "SELECT * FROM c"
        items = list(container.query_items(query=query, enable_cross_partition_query=True))

        return items
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/books/{book_id}")
async def getBook(book_id: str):
    """
    Retrieves a specific book entry from the database.

    This function is triggered by an HTTP GET request with a book ID parameter.
    It retrieves the book document with the specified ID from the Cosmos DB
    container and returns it. If the book is not found, it returns an HTTP 404
    response.

    Args:
        book_id (str): The unique identifier of the book to retrieve.

    Returns:
        dict: The book document with the specified ID.
        Raises HTTPException with status code 404 if the book is not found.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Query the book by ID
        query = f"SELECT * FROM c WHERE c.id = '{book_id}'"
        items = list(container.query_items(query=query, enable_cross_partition_query=True))

        if items:
            return items[0]
        else:
            raise HTTPException(status_code=404, detail="Book not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
from azure.cosmos.exceptions import CosmosResourceNotFoundError

@app.put("/api/books/{book_id}")
async def updateBook(book_id: str, book: UpdateBook):
    """
    Updates a specific book entry in the database.

    This function is triggered by an HTTP PUT request with a book ID parameter
    and a JSON payload containing the updated book data. It validates the data
    using the UpdateBook model and then updates the book document in the Cosmos
    DB container. If the book is not found or the data is invalid, it returns
    an appropriate HTTP response.

    Args:
        book_id (str): The unique identifier of the book to update.
        book (UpdateBook): The HTTP request object containing the updated book data.

    Returns:
        dict: The updated book document.
        Raises HTTPException with status code 400 if the request data is invalid or not in JSON format.
        Raises HTTPException with status code 404 if the book is not found.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Retrieve the existing document
        try:
            existing_book = container.read_item(item=book_id, partition_key=book_id)
        except CosmosResourceNotFoundError:
            raise HTTPException(status_code=404, detail="Book not found")

        # Update the document with fields provided in the request
        update_data = book.model_dump()
        for field, value in update_data.items():
            if field in existing_book and value is not None:
                existing_book[field] = value

        # Upsert the updated document
        container.upsert_item(existing_book)
        return existing_book
    except ValidationError as ve:
        raise HTTPException(status_code=400, detail="Invalid input data")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.delete("/api/books/{book_id}")
async def deleteBook(book_id: str):
    """
    Deletes a specific book entry from the database.

    This function is triggered by an HTTP DELETE request with a book ID parameter.
    It deletes the book document with the specified ID from the Cosmos DB container.
    If the book is not found, it returns an HTTP 404 response.

    Args:
        book_id (str): The unique identifier of the book to delete.

    Returns:
        dict: A message confirming the deletion of the book.
        Raises HTTPException with status code 404 if the book is not found.
        Raises HTTPException with status code 500 if an unexpected error occurs.
    """

    try:
        # Query the book by ID
        query = f"SELECT * FROM c WHERE c.id = '{book_id}'"
        items = list(container.query_items(query=query, enable_cross_partition_query=True))

        if items:
            # Delete the book from the database
            container.delete_item(item=items[0])
            return {"message": "Book deleted successfully"}
        else:
            raise HTTPException(status_code=404, detail="Book not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

