#!/usr/bin/python3
from models.base_model import BaseModel

model = BaseModel(name="My First Model", my_number=89)

print("Model before saving:")
print(model)

model.save()

# Print model details after saving
print("Model after saving:")
print(model)

my_model_json = model.to_dict()
print(f"JSON representation: {my_model_json}")
print("JSON details:")
for key, value in my_model_json.items():
    print(f"\t{key}: ({type(value)}) - {value}")