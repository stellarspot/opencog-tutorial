from opencog.type_constructors import *


def mul(num1, num2):
    n1 = float(num1.name)
    n2 = float(num2.name)
    return NumberNode(str(n1 * n2))
