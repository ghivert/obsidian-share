import styled
import styled/media
import styled/size.{px}

pub fn display() {
  styled.class([
    styled.max_width(px(500)),
    styled.color("red"),
    styled.background("red"),
    styled.hover([styled.background("blue")]),
    styled.media(media.max_width(px(1024)), [
      styled.max_width(px(300)),
      styled.color("blue"),
      styled.hover([styled.background("blue")]),
    ]),
    styled.media(media.max_width(px(1024)), [
      styled.max_width(px(300)),
      styled.color("blue"),
      styled.hover([styled.background("blue")]),
    ]),
  ])
  |> styled.memo()
}
