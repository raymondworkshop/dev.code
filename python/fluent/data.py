"""
ch5 - Data Class Builders - a collection of fields
"""

"""
import typing

class City(typing.NamedTuple):
    continent: str
    name: str
    country: str
"""


# data class
from dataclasses import dataclass
from typing import List

@dataclass
class City:
    continent: str
    name: str
    country: str


def match_asian_cities(cities: List[City]):
    results = []
    for city in cities:
        match city:
            case City(continent='Asia'):
                results.append(city)

    return results


# Dataclasses are suitable for storing objects data
# dataclasses automates the creation of the __init__() constructor method
from dataclasses import dataclass, field
from typing import Union, List, Optional

#composition here
# a class contains an object of another class known to as components  
# one advantage is that a change rarely affects another, 
# thus enables code adaptability and code base changes without introducing problems  
#
@dataclass
class Address:
    street: str
    city: str
    state: str
    zipcode: str =""
    street2: Optional[str] = ""

    def __str__(self) -> str:
        """ provides pretty response of address ."""
        lines = [self.street]
        if self.street2:
            lines.append(self.street2)
        lines.append(f"{self.city}, {self.state} {self.zipcode}")
        return "\n".join(lines)

@dataclass
class Employee:
    id: int
    name: str
    address: Address = None  #component
    working_hrs: int = field(default=40)

    def employeeinfo(self):
        return f"employee name is {self.name} with id {self.id}"

@dataclass
class SalaryEmployee(Employee):
    """ add weekly_salary data
    """
    weekly_salary: Union[float, int] = 0

    def calculate_payroll(self) -> Union[float, int]:
        """ calulate the payroll and returns pay"""
        return self.weekly_salary

class PayrollSystem:
    def calculate_pauroll(self,employees: List[Employee]) -> None:
        for employee in employees:
            print(f"Payroll for: {employee.id} - {employee.name}")
            print(f"- Check amount: {employee.calculate_payroll()}")
            if employee.address:
                print(" - Sent to:")
                print(employee.address)
            print("")


def test_payroll_system():
    manager = SalaryEmployee(1, "Raymond", weekly_salary=1500)
    secretary = SalaryEmployee (2, "john",weekly_salary=700 )
    secretary.address = Address("67", "HK", "NH")


    payroll_system = PayrollSystem()
    payroll_system.calculate_pauroll([manager, secretary])



def main():
    #print(cities)
    cities = [
    City("Asia", "Tokyo", "JP"),
    City("Asia", "Delhi", "IN"),
    City("North America", "Mexico City", "MX"),
    City("North America", "New York", "US"),
    City("South America", "São Paulo", "BR"),
    ]
    print(match_asian_cities(cities))

    test_payroll_system()

    return


if __name__ == "__main__":
    main()
