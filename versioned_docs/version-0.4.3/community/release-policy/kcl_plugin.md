# KCL Plugin Release Policy

The original intention of the KCL plug-in is to extend the functions of the KCL language, and its positioning is not to completely replicate the entire ecology of the general programming language. Therefore, the KCL plug-in has deliberately made some necessary restrictions: first, plug-ins cannot import each other; Second, plug-ins cannot have the same name in the same module; Finally, the plug-in guide implemented by Python uses the functions provided by the standard library and plug-in framework.
