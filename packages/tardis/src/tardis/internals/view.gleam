import gleam/list
import gleam/option.{type Option}
import gleam/pair
import gleam/string
import lustre/element.{type Element}
import lustre/element/html as h
import lustre/event
import tardis/internals/data.{type Data}
import tardis/internals/data/debugger.{type Debugger}
import tardis/internals/data/msg.{type Msg}
import tardis/internals/data/step.{type Step, Step}
import tardis/internals/styles as s

pub fn view_model(opened: Bool, debugger_: String, model: Debugger) {
  let selected = model.selected_step
  case opened {
    False -> element.none()
    True ->
      element.keyed(h.div([s.body()], _), {
        model.steps
        |> list.map(fn(i) { #(i.index, view_step(debugger_, selected, i)) })
        |> list.prepend(#("header", view_grid_header(opened, model)))
      })
  }
}

fn view_step(debugger_: String, selected_step: Option(String), item: Step) {
  let Step(index, model, msg) = item
  let class = case option.unwrap(selected_step, "") == index {
    True -> s.selected_details()
    False -> s.details()
  }
  h.div([class, event.on_click(msg.BackToStep(debugger_, item))], [
    h.div([s.step_index()], [h.text(index)]),
    h.div([s.step_msg()], view_data(data.inspect(msg), 0, "")),
    h.div([s.step_model()], view_data(data.inspect(model), 0, "")),
  ])
}

fn view_data_line(indent: Int, prefix: String, text: String, color: String) {
  let idt = string.repeat(" ", times: indent)
  let text_color = s.text_color(color)
  case string.length(prefix) {
    0 -> h.div([text_color], [h.text(idt <> text)])
    _ ->
      h.div([s.flex()], [
        h.div([s.keyword_color()], [h.text(idt <> prefix)]),
        h.div([text_color], [h.text(text)]),
      ])
  }
}

fn select_grid_header_class(opened: Bool, model: Debugger) {
  case opened, model.count {
    False, _ | True, 1 -> s.grid_header()
    True, _ -> s.bordered_grid_header()
  }
}

fn view_grid_header(opened: Bool, model: Debugger) {
  h.div([select_grid_header_class(opened, model)], [
    h.div([s.subgrid_header()], [h.text("Step")]),
    h.div([s.subgrid_header()], [h.text("Msg")]),
    h.div([s.subgrid_header()], [h.text("Model")]),
  ])
}

fn view_data(data: Data, indent i: Int, prefix p: String) -> List(Element(Msg)) {
  case data {
    data.DataNil -> [view_data_line(i, p, "Nil", "var(--nil)")]
    data.DataBool(v) -> [view_data_line(i, p, v, "var(--bool)")]
    data.DataConstant(v) -> [view_data_line(i, p, v, "var(--constant)")]
    data.DataBitArray(v) -> [view_data_line(i, p, v, "var(--bit-array)")]
    data.DataUtfCodepoint(v) -> [view_data_line(i, p, v, "var(--utfcodepoint)")]
    data.DataString(v) -> [view_data_line(i, p, v, "var(--string)")]
    data.DataNumber(v) -> [view_data_line(i, p, v, "var(--number)")]
    data.DataRegex(v) -> [view_data_line(i, p, v, "var(--regex)")]
    data.DataDate(v) -> [view_data_line(i, p, v, "var(--date)")]
    data.DataFunction(v) -> [view_data_line(i, p, v, "var(--function)")]
    data.DataTuple(vs) -> view_data_tuple(vs, p, i)
    data.DataList(vs) -> view_data_list(vs, p, i)
    data.DataCustomType(name, vs) -> view_data_custom_type(name, vs, p, i)
    data.DataDict(vs) -> view_data_dict(vs, p, i)
    data.DataSet(vs) -> view_data_set(vs, p, i)
    data.DataObject(name, vs) -> view_data_object(name, vs, p, i)
  }
}

fn view_data_tuple(values: List(Data), prefix p: String, indent i: Int) {
  list.concat([
    [view_data_line(i, p, "#(", "var(--editor-fg)")],
    list.flat_map(values, view_data(_, i + 2, "")),
    [view_data_line(i, p, ")", "var(--editor-fg)")],
  ])
}

fn view_data_list(values: List(Data), prefix p: String, indent i: Int) {
  list.concat([
    [view_data_line(i, p, "(", "var(--editor-fg)")],
    list.flat_map(values, view_data(_, i + 2, "")),
    [view_data_line(i, p, ")", "var(--editor-fg)")],
  ])
}

fn view_data_custom_type(
  name: String,
  values: List(#(Option(String), Data)),
  prefix p: String,
  indent i: Int,
) {
  list.concat([
    [view_data_line(i, p, name <> "(", "var(--custom-type)")],
    list.flat_map(values, fn(data) {
      let prefix = option.unwrap(pair.first(data), "")
      view_data(pair.second(data), i + 2, prefix)
    }),
    [view_data_line(i, p, ")", "var(--custom-type)")],
  ])
}

fn view_data_dict(values: List(#(Data, Data)), prefix p: String, indent i: Int) {
  list.concat([
    [view_data_line(i, p, "//js dict.from_list(", "var(--editor-fg)")],
    list.flat_map(values, fn(data) {
      view_data(pair.second(data), i + 2, data.stringify(pair.first(data)))
    }),
    [view_data_line(i, p, ")", "var(--editor-fg)")],
  ])
}

fn view_data_set(vs: List(Data), prefix p: String, indent i: Int) {
  list.concat([
    [view_data_line(i, p, "//js Set(", "var(--editor-fg)")],
    list.flat_map(vs, view_data(_, i + 2, "")),
    [view_data_line(i, p, ")", "var(--editor-fg)")],
  ])
}

fn view_data_object(
  name: String,
  vs: List(#(Data, Data)),
  prefix p: String,
  indent i: Int,
) {
  list.concat([
    [view_data_line(i, p, name <> " {", "var(--editor-fg)")],
    list.flat_map(vs, fn(data) { view_data(pair.second(data), i + 2, "") }),
    [view_data_line(i, p, "}", "var(--editor-fg)")],
  ])
}
