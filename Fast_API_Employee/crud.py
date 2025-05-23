from sqlalchemy.orm import Session
import models, schemas

def get_employee(db: Session, emp_id: int):
    return db.query(models.Employee).filter(models.Employee.id == emp_id).first()

def get_employees(db: Session):
    return db.query(models.Employee).all()

def create_employee(db: Session, emp: schemas.EmployeeCreate):
    new_emp = models.Employee(**emp.dict())
    db.add(new_emp)
    db.commit()
    db.refresh(new_emp)
    return new_emp

def update_employee(db: Session, emp_id: int, data: schemas.EmployeeUpdate):
    emp = get_employee(db, emp_id)
    if not emp:
        return None
    for key, value in data.dict().items():
        setattr(emp, key, value)
    db.commit()
    return emp

def delete_employee(db: Session, emp_id: int):
    emp = get_employee(db, emp_id)
    if not emp:
        return None
    db.delete(emp)
    db.commit()
    return emp
