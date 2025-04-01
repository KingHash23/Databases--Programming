# from graphviz import Digraph

# def generate_eerd():
#     dot = Digraph("InclusiveEducationEERD")
    
#     # Entities
#     dot.node("ST", "Student")
#     dot.node("TE", "Teacher")
#     dot.node("PA", "Parent/Guardian")
#     dot.node("AR", "Accessibility Request")
#     dot.node("LP", "Learning Plan")
#     dot.node("RE", "Resource")
#     dot.node("AD", "Administrator")
    
#     # Relationships
#     dot.edge("ST", "PA", label="Has")  # A student has at least one parent
#     dot.edge("ST", "TE", label="Assigned to")  # A student is assigned to one teacher
#     dot.edge("ST", "AR", label="Submits")  # A student submits multiple accessibility requests
#     dot.edge("AR", "AD", label="Approved by")  # Accessibility requests are approved by an admin
#     dot.edge("ST", "LP", label="Follows")  # A student follows one or more learning plans
#     dot.edge("TE", "LP", label="Creates")  # Teachers create learning plans
#     dot.edge("RE", "ST", label="Allocated to")  # Resources are assigned to students
#     dot.edge("AD", "RE", label="Manages")  # Administrators manage resource allocation
    
#     return dot.source

# eerd_diagram = generate_eerd()
# print(eerd_diagram)




from graphviz import Digraph

def generate_eerd():
    dot = Digraph("InclusiveEducationEERD")
    
    # Entities with Attributes
    dot.node("ST", "Student\n- StudentID (PK)\n- Name\n- Age\n- Gender\n- DisabilityType\n- ContactInfo\n- GuardianID (FK)")
    dot.node("TE", "Teacher\n- TeacherID (PK)\n- Name\n- Subject\n- ContactInfo")
    dot.node("PA", "Parent/Guardian\n- GuardianID (PK)\n- Name\n- ContactInfo\n- Relationship")
    dot.node("AR", "Accessibility Request\n- RequestID (PK)\n- StudentID (FK)\n- RequestType\n- Status\n- SubmissionDate\n- AdminID (FK)")
    dot.node("LP", "Learning Plan\n- PlanID (PK)\n- StudentID (FK)\n- TeacherID (FK)\n- Subject\n- Goals\n- Progress")
    dot.node("RE", "Resource\n- ResourceID (PK)\n- Name\n- Type\n- Availability\n- AllocatedTo (FK)")
    dot.node("AD", "Administrator\n- AdminID (PK)\n- Name\n- Role\n- ContactInfo")
    
    # Relationships
    dot.edge("ST", "PA", label="Has")  # A student has at least one parent
    dot.edge("ST", "TE", label="Assigned to")  # A student is assigned to one teacher
    dot.edge("ST", "AR", label="Submits")  # A student submits multiple accessibility requests
    dot.edge("AR", "AD", label="Approved by")  # Accessibility requests are approved by an admin
    dot.edge("ST", "LP", label="Follows")  # A student follows one or more learning plans
    dot.edge("TE", "LP", label="Creates")  # Teachers create learning plans
    dot.edge("RE", "ST", label="Allocated to")  # Resources are assigned to students
    dot.edge("AD", "RE", label="Manages")  # Administrators manage resource allocation
    
    return dot.source

eerd_diagram = generate_eerd()
print(eerd_diagram)
