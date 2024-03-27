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
