from pydantic import BaseModel, Field
from uuid import uuid4

# Book schema for creating
class Book(BaseModel):
    """
    Represents a book with properties to store in a database.

    Attributes:
        id (str): Unique identifier for the book, automatically generated.
        title (str): The title of the book.
        author (str): The author of the book.
        isbn (str, optional): The International Standard Book Number of the book. Defaults to None.
        publishedDate (str, optional): The publication date of the book. Defaults to None.
        genre (str, optional): The genre of the book. Defaults to None.
    """
    id: str = Field(default_factory=lambda: str(uuid4()))
    title: str
    author: str
    isbn: str = None
    publishedDate: str = None
    genre: str = None

# Book schema for updating
class UpdateBook(BaseModel):
    """
    Represents the schema for updating a book's information.
    
    Attributes:
        title (str): The title of the book. Optional.
        author (str): The author of the book. Optional.
        isbn (str): The ISBN of the book. Optional.
        publishedDate (str): The publication date of the book. Optional.
        genre (str): The genre of the book. Optional.
    """
    title: str = None
    author: str = None
    isbn: str = None
    publishedDate: str = None
    genre: str = None