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
  return nodes.reduce((acc, val) => {
    const dimensions = val.getBoundingClientRect()
    return Math.max(window.innerHeight - dimensions.top - 12, acc)
  }, 0)
}

export function computeToastSize(id) {
  const node = document.getElementsByClassName(`toaster-toast-${id}`)
  if (node) return node[0].getBoundingClientRect().height - 12
  return 0
}
