#!/usr/bin/python3
from models.base_model import BaseModel

my_model = BaseModel(name="My_First_Model", my_number=89)

print(f"Model ID: {my_model.id}")
print(my_model)  
print(f"Created at type: {type(my_model.created_at)}")

my_model_json = my_model.to_dict()
print(f"JSON representation: {my_model_json}")
print("JSON details:")
for key, value in my_model_json.items():
    print(f"\t{key}: ({type(value)}) - {value}")

my_new_model = BaseModel(**my_model_json)
print(f"New model ID: {my_new_model.id}")
print(my_new_model)
print(f"New model created at type: {type(my_new_model.created_at)}")

print(f"Are the models the same object? {my_model is my_new_model}")
