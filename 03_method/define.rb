# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  define_method "//" do
    "//"
  end
end
# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
class A2
  def initialize(names)
    names.each do |name|
      method_name = "hoge_#{name}"
      define_singleton_method method_name do |arg|
        return dev_team unless arg

        method_name * arg
      end
    end
  end

  def dev_team
    "SmartHR Dev Team"
  end
end
# Q3.
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること
module OriginalAccessor
  def self.included(klass)
    klass.define_singleton_method :my_attr_accessor do |arg|
      define_method arg do
        instance_variable_get("@#{arg}")
      end

      define_method "#{arg}=" do |val|
        instance_variable_set("@#{arg}", val)

        if val == true || val == false
          define_singleton_method "#{arg}?" do
            send(arg)
          end
        end
      end
    end
  end
end
