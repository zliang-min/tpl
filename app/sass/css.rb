def my_table(cssClass = nil)
  table '#hello'
  c(:abc).and( id(:opq) {
  }
  table[cssClass] {
    self.abc#fie
    + compact
    width 30.px
    height 40.px
    th {
      width 50.px
      self['.short'] {
        width 10.px
      }
      thead[self] {
        background width: 10.px, style: 'solid', color: color.red
      }
    }
  }
end

or

style :my_table do |cssClass = nil, options = {}|
end

+ my_table
+ my_table('.hello')
+ my_table('.world')
