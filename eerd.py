from graphviz import Digraph

# Create EERD Diagram
dot = Digraph("InclusiveEducationEERD")

# Entities with Attributes
dot.node("ST", "Student\n- StudentID (PK)\n- Name\n- Age\n- Gender\n- DisabilityType\n- ContactInfo\n- GuardianID (FK)")
dot.node("TE", "Teacher\n- TeacherID (PK)\n- Name\n- Subject\n- ContactInfo")
dot.node("PA", "Parent/Guardian\n- GuardianID (PK)\n- Name\n- ContactInfo\n- Relationship")
dot.node("AR", "Accessibility Request\n- RequestID (PK)\n- StudentID (FK)\n- RequestType\n- Status\n- SubmissionDate\n- AdminID (FK)")
dot.node("LP", "Learning Plan\n- PlanID (PK)\n- StudentID (FK)\n- TeacherID (FK)\n- Subject\n- Goals\n- Progress")
dot.node("RE", "Resource\n- ResourceID (PK)\n- Name\n- Type\n- Availability\n- AllocatedTo (FK)")
dot.node("AD", "Administrator\n- AdminID (PK)\n- Name\n- Role\n- ContactInfo")

# Relationships with Multiplicities
dot.edge("ST", "PA", label="1..* has 1")  # A student must have at least one parent
dot.edge("ST", "TE", label="1 assigned to 1..*")  # A student is assigned to one teacher, but a teacher handles multiple students
dot.edge("ST", "AR", label="1 submits 0..*")  # A student can submit multiple accessibility requests
dot.edge("AR", "AD", label="1..* approved by 1")  # An administrator approves multiple requests
dot.edge("ST", "LP", label="1 follows 1..*")  # A student follows at least one learning plan
dot.edge("TE", "LP", label="1..* creates 1..*")  # A teacher creates multiple learning plans, and each plan can involve multiple teachers
dot.edge("RE", "ST", label="1 allocated to 0..*")  # A resource is allocated to students as needed
dot.edge("AD", "RE", label="1 manages 1..*")  # Administrators manage multiple resources

# Save and render the diagram
eer_image_path = "/mnt/data/InclusiveEducationEERD.png"
dot.render(eer_image_path, format="png", cleanup=True)
eer_image_path









# Regenerate the EERD with cardinalities explicitly shown

dot = Digraph("InclusiveEducationEERD")

# Entities with Attributes
dot.node("ST", "Student\n- StudentID (PK)\n- Name\n- Age\n- Gender\n- DisabilityType\n- ContactInfo\n- GuardianID (FK)")
dot.node("TE", "Teacher\n- TeacherID (PK)\n- Name\n- Subject\n- ContactInfo")
dot.node("PA", "Parent/Guardian\n- GuardianID (PK)\n- Name\n- ContactInfo\n- Relationship")
dot.node("AR", "Accessibility Request\n- RequestID (PK)\n- StudentID (FK)\n- RequestType\n- Status\n- SubmissionDate\n- AdminID (FK)")
dot.node("LP", "Learning Plan\n- PlanID (PK)\n- StudentID (FK)\n- TeacherID (FK)\n- Subject\n- Goals\n- Progress")
dot.node("RE", "Resource\n- ResourceID (PK)\n- Name\n- Type\n- Availability\n- AllocatedTo (FK)")
dot.node("AD", "Administrator\n- AdminID (PK)\n- Name\n- Role\n- ContactInfo")

# Relationships with explicit cardinalities
dot.edge("ST", "PA", label="(M) belongs to (1)")  # A student has one guardian, but a guardian can have multiple students
dot.edge("ST", "TE", label="(M) assigned to (1)")  # A student is assigned to one teacher, but a teacher handles multiple students
dot.edge("ST", "AR", label="(1) submits (0..M)")  # A student can submit multiple accessibility requests
dot.edge("AR", "AD", label="(M) approved by (1)")  # An administrator approves multiple requests
dot.edge("ST", "LP", label="(1) follows (1..M)")  # A student follows at least one learning plan
dot.edge("TE", "LP", label="(1) creates (1..M)")  # A teacher creates multiple learning plans, and each plan can involve multiple teachers
dot.edge("RE", "ST", label="(1) allocated to (0..M)")  # A resource is allocated to students as needed
dot.edge("AD", "RE", label="(1) manages (1..M)")  # Administrators manage multiple resources

# Save and render the updated diagram
eer_image_path = "/mnt/data/InclusiveEducationEERD_with_Cardinalities.png"
dot.render(eer_image_path, format="png", cleanup=True)
eer_image_path
