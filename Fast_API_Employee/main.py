from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
import models, schemas, crud
from database import SessionLocal, engine, Base

app = FastAPI()
Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/employees", response_model=schemas.Employee, status_code=201)
def create_employee(emp: schemas.EmployeeCreate, db: Session = Depends(get_db)):
    return crud.create_employee(db, emp)

@app.get("/employees", response_model=list[schemas.Employee])
def read_employees(db: Session = Depends(get_db)):
    return crud.get_employees(db)

@app.get("/employees/{emp_id}", response_model=schemas.Employee)
def read_employee(emp_id: int, db: Session = Depends(get_db)):
    emp = crud.get_employee(db, emp_id)
    if not emp:
        raise HTTPException(status_code=404, detail="Employee not found")
    return emp

@app.put("/employees/{emp_id}", response_model=schemas.Employee)
def update_employee(emp_id: int, data: schemas.EmployeeUpdate, db: Session = Depends(get_db)):
    emp = crud.update_employee(db, emp_id, data)
    if not emp:
        raise HTTPException(status_code=404, detail="Employee not found")
    return emp

@app.delete("/employees/{emp_id}", status_code=204)
def delete_employee(emp_id: int, db: Session = Depends(get_db)):
    emp = crud.delete_employee(db, emp_id)
    if not emp:
        raise HTTPException(status_code=404, detail="Employee not found")
