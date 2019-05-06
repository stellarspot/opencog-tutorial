(use-modules
 (opencog)
 (opencog exec)
 (opencog python))

(python-eval "exec(open('example_python_code.py').read())")

(display
 (cog-execute!
  (ExecutionOutputLink
   (GroundedSchemaNode "py: mul")
   (ListLink
    (Number 2)
    (Number 3)))))
