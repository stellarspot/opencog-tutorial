(use-modules (opencog) (opencog exec))

(Define
 (DefinedSchema "add")
 (Lambda
  (VariableList
   (Variable "$X")
   (Variable "$Y"))
  (Plus
   (Variable "$X")
   (Variable "$Y"))))

(display
 (cog-execute!
  (ExecutionOutput
   (DefinedSchema "add")
   (List
    (Number "2")
    (Number "3")))))
