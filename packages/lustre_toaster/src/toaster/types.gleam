import toaster/model/toast.{type Level}

pub type Msg {
  NewToast(String, Level)
  ShowToast(Int)
  HideToast(Int, Int)
  RemoveToast(Int)
  StopToast(Int)
  ResumeToast(Int)
}
