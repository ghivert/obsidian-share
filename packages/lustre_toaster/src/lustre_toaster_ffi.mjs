let storeDispatcher_ = null

export function storeDispatcher(dispatcher) {
  if (storeDispatcher_ !== null) throw new Error("You should not instanciate two toaster instance")
  storeDispatcher_ = dispatcher
  return dispatcher
}

export function getDispatcher() {
  if (storeDispatcher_ === null) throw new Error("You should instanciate toaster")
  return storeDispatcher_
}

export function isDarkTheme() {
  const matches = matchMedia('(prefers-color-scheme: dark)')
  return matches.matches
}

export function computeBottomPosition() {
  const [...nodes] = document.getElementsByClassName('toaster-toast')
  return nodes.reduce((acc, node) => {
    if (node.classList.contains('toaster-toast-hidden')) return acc
    const dimensions = node.getBoundingClientRect()
    return acc + dimensions.height - 12;
  }, 0)
}

export function computeToastSize(id) {
  const node = document.getElementsByClassName(`toaster-toast-${id}`)
  if (node && node[0]) {
    if (node[0].classList.contains('toaster-toast-visible'))
      return node[0].getBoundingClientRect().height - 12
  }
  return 0
}

export function createNode() {
  const node = document.createElement('div')
  node.setAttribute('id', 'grille-pain')
  document.body.appendChild(node)
}
