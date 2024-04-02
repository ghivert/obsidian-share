pub type Options {
  Options(timeout: Int)
}

pub fn default() -> Options {
  Options(timeout: 5000)
}

pub fn timeout(options: Options, timeout: Int) -> Options {
  Options(..options, timeout: timeout)
}
