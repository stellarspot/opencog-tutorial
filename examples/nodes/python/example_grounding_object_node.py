from opencog.type_constructors import *
from opencog.utilities import initialize_opencog
from opencog.bindlink import execute_atom

# Initialize AtomSpace
atomspace = AtomSpace()
initialize_opencog(atomspace)


# Class to be stored in GroundedObjectNode
class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def get_x(self):
        return self.x

    def get_y(self):
        return self.x

    def move(self, x, y):
        self.x += x
        self.y += y

    def __str__(self):
        return "Point(%d, %d)" % (self.x, self.y)


point = Point(2, 3)
print("point:", point)

GroundedObjectNode("point", point, unwrap_args=True)

apply_link = ApplyLink(
    MethodOfLink(
        GroundedObjectNode("point"),
        ConceptNode("move")
    ),
    ListLink(
        GroundedObjectNode("x", 3),
        GroundedObjectNode("y", 4)
    )
)

execute_atom(atomspace, apply_link)

print("point:", point)
