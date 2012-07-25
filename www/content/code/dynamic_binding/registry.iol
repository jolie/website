include "types/Binding.iol"

interface RegistryInterface {
RequestResponse: getBinding(string)(Binding)
}
