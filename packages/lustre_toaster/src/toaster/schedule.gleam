import lustre/effect
import scheduler/timer

pub fn schedule(duration: Int, msg: msg) {
  effect.from(fn(dispatch) {
    use <- timer.set_timeout(duration)
    dispatch(msg)
  })
}
