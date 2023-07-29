import logging
from sys import argv
import yaml

AL_TYPE_SPEC = {
        "float": "f",
        "int": "i",
        
        }

class CodeGen:
    def __init__(self, in_file_name, out_file_base):
        with open(in_file_name, "rb") as in_file:
            self.data = yaml.safe_load(in_file)
        self.pyx = open(out_file_base + ".pyx", "w")
        self.pyx.write("# cython: language_level=3\n\n")
        self.pxd = open(out_file_base + ".pxd", "w")
        self.pxd.write("# cython: language_level=3\n\n")

    def __del__(self):
        self.pyx.close()
        self.pxd.close()

    def generate(self):
        # Write the file prelude (if any)
        try:
            self.pyx.write(self.data["pyx_prelude"])
        except KeyError: pass
        try:
            self.pxd.write(self.data["pxd_prelude"])
        except KeyError: pass
        logging.info(f"Generating subclasses of {len(self.data['classes'])} superclasses")
        for superclass, subclasses in self.data["classes"].items():
            superclass = superclass[:-1].capitalize()
            self.gen_subclasses(superclass, subclasses)

    def gen_subclasses(self, superclass, subclasses):
        logging.info(f"Generating {len(subclasses)} subclasses of {superclass}")
        for cls_name, cls_desc in subclasses.items():
            # Write out the class declaration to the pxd file
            self.pxd.write(f"\n\ncdef class {cls_name}{superclass}({superclass}): pass")
            # Write the start of the definition to the pyx file
            self.pyx.write(f"""\n
cdef class {cls_name}{superclass}({superclass}):
    {repr(cls_desc.get('doc', ''))}

    cdef void init_with_id(self, EfxExtension efx, al.ALuint id):
        {superclass}.init_with_id(self, efx, id)
        self.type = "{cls_desc["al_effect"].upper()}"
    """)
        # Define the properties
        for prop in cls_desc["properties"]:
            self.gen_prop(superclass=superclass, subclass=cls_name, **prop)

    def gen_prop(self, name, type, superclass, subclass, doc=""):
        logging.info(f"Generating {type} property {name}")
        if type == "v3f":
            # We have to handle this differently
            self.pyx.write(f"""
    @property
    def {name}(self):
        {repr(doc)}
        cdef al.ALfloat x, y, z
        self.efx.alGet{superclass}3f(self.id, self.efx.AL_{subclass.upper()}_{name.upper()}, &x, &y, &z)
        check_al_error()
        return V3f(x, y, z)

    @{name}.setter
    def {name}(self, val):
        self.efx.al{superclass}3f(self.id, self.efx.AL_{subclass.upper()}_{name.upper()}, val[0], val[1], val[2])
        check_al_error()
            """)
        else:
            self.pyx.write(f"""
    @property
    def {name}(self):
        {repr(doc)}
        cdef al.AL{type} val
        self.efx.alGet{superclass}{AL_TYPE_SPEC[type]}(self.id, self.efx.AL_{subclass.upper()}_{name.upper()}, &val)
        check_al_error()
        return val

    @{name}.setter
    def {name}(self, val):
        self.efx.al{superclass}{AL_TYPE_SPEC[type]}(self.id, self.efx.AL_{subclass.upper()}_{name.upper()}, val)
        check_al_error()
            """)

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    in_file_name = argv[1] if len(argv) > 1 else "efx_classes.yaml"
    out_file_base = argv[2] if len(argv) > 2 else "cyal/efx"
    cg = CodeGen(in_file_name, out_file_base)
    cg.generate()
