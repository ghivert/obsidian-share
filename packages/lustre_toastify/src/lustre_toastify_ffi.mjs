let storeDispatcher_ = null

export function storeDispatcher(dispatcher) {
  if (storeDispatcher_ !== null) throw new Error("You should not instanciate two toastify instance")
  storeDispatcher_ = dispatcher
  return dispatcher
}

export function getDispatcher() {
  if (storeDispatcher_ === null) throw new Error("You should instanciate toastify")
  return storeDispatcher_
}
