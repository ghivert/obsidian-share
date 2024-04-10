import gleam/dynamic
import plinth/browser/document
import plinth/browser/element.{type Element}
import plinth/browser/shadow
import tardis/stylesheet.{stylesheet}

@external(javascript, "../tardis.ffi.mjs", "addCustomStyles")
fn add_custom_styles(content: String) -> Nil

pub fn instanciate_shadow_root(element: Element) {
  // Instanciate the Shadow DOM wrapper.
  let div = document.create_element("div")
  let root = shadow.attach_shadow(div, shadow.Open)
  element.append_child(document.body(), div)
  element.set_attribute(div, "class", "tardis")
  shadow.append_child(root, element)
  root
}

pub fn instanciate_lustre_root() {
  // Instanciate the Shadow DOM lustre node.
  let root = document.create_element("div")
  element.set_attribute(root, "id", "tardis-start")
  root
}

pub fn mount_shadow_node() {
  // Add Lexend in the DOM.
  add_custom_styles(stylesheet)
  let lustre_root_ = instanciate_lustre_root()
  let shadow_root = instanciate_shadow_root(lustre_root_)
  // Trick to fool lustre application.
  // Please children, don't do this at home.
  let lustre_root: String = dynamic.unsafe_coerce(dynamic.from(lustre_root_))
  #(shadow_root, lustre_root)
}
