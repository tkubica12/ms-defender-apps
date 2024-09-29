from pydantic import BaseModel, Field
from uuid import uuid4

# Customer schema for creating
class Customer(BaseModel):
    """
    Represents a customer with properties to store in a database.

    Attributes:
        id (str): Unique identifier for the customer, automatically generated.
        name (str): The name of the customer.
        email (str): The email address of the customer.
        phone (str, optional): The phone number of the customer. Defaults to None.
        address (str, optional): The address of the customer. Defaults to None.
    """
    id: str = Field(default_factory=lambda: str(uuid4()))
    name: str
    email: str
    phone: str = None
    address: str = None

# Customer schema for updating
class UpdateCustomer(BaseModel):
    """
    Represents the schema for updating a customer's information.
    
    Attributes:
        name (str): The name of the customer. Optional.
        email (str): The email address of the customer. Optional.
        phone (str): The phone number of the customer. Optional.
        address (str): The address of the customer. Optional.
    """
    name: str = None
    email: str = None
    phone: str = None
    address: str = None