#import "simplepaper.typ": *

#show: project.with(
  title: "矩阵理论作业",
  authors: (
    (
      name: "杨永浩",
    ),
  ),
)

= 第一章

#problem[
  T27
]

首先需要知道两个结论:
+ 乘矩阵，循环交换位置，迹不变 #link("https://blog.csdn.net/weixin_43660703/article/details/108686621#:~:text=%E5%8D%B3%E4%BD%BF%E5%BE%AA%E7%8E%AF%E7%BD%AE%E6%8D%A2%E5%90%8E%E7%9F%A9%E9%98%B5%E4%B9%98%E7%A7%AF%E5%BE%97%E5%88%B0%E7%9A%84%E7%9F%A9%E9%98%B5%E5%BD%A2%E7%8A%B6%E5%8F%98%E4%BA%86%EF%BC%8C%E8%BF%B9%E8%BF%90%E7%AE%97%E7%9A%84%E7%BB%93%E6%9E%9C%E4%BE%9D%E7%84%B6%E4%B8%8D%E5%8F%98%EF%BC%9A%20T%20r%20%28A%20B%29%20%3D%20T%20r,A%29%20Tr%20%28AB%29%3DTr%20%28BA%29%20T%20r%28AB%29%3D%20T%20r%28BA%29")[矩阵迹的相关结论证明]
+ 半正定Hermite矩阵一定有其对应的平方根,其也是Hermite矩阵 #link("https://math.fandom.com/zh/wiki/%E7%9F%A9%E9%98%B5%E5%B9%B3%E6%96%B9%E6%A0%B9")[矩阵平方根]

$
  tr(A B) &= tr(A^0.5 A^0.5 B)\
  &= tr(A^0.5 B A^0.5)\
  &= tr(A^0.5 B^0.5 B^0.5 A^0.5)\
  &= tr((B^0.5 A^0.5)^H B^0.5 A^0.5)\
  &=0
$
这说明 $B^0.5 A^0.5$ 所有元素模值的平方和为0，从而有 $B^0.5 A^0.5 = 0$ ，则有这说明 $B^0.5 A^0.5$ 所有元素模值的平方和为0，从而有 $B^0.5 A^0.5 = 0$ ，则有

$
  A B &= A^0.5 A^0.5 B^0.5 B^0.5\
  &= A^0.5 (B^0.5 A^0.5)^H B^0.5\
  &= A^0.5 0 B^0.5\
  &= 0
$



#problem[
  设下列文法生成变量的类型说明：
  $
    D -> "id" L \
    L -> , "id" L | : T \
    T -> "integer" | "real"
  $
  构造一个翻译模式，把每个标识符的类型存入符号表。
]

#solution[
  设 D, L, T 有综合属性 type。

  addtype(id, type)将标识符 id 及其类型 type 填入符号表中。

  翻译模式如下：
  #table(
    columns: (auto, 1fr),
    inset: 10pt,
    align: center,
    [$D -> "id" L$], [${"addtype"("id" . "entry", L . "type")}$],
    [$L -> , "id" L_1$], [${"addtype"("id" . "entry", L_1 . "type" ; L . "type" := L_1 . "type")}$],
    [$L -> :T$], [${L . "type" := T . "type"}$],
    [$T -> "integer"$], [${T . "type" := "integer"}$],
    [$T -> "real"$], [${T . "type" := "real"}$],
  )

]

#problem[
  文法G的产生式如下：
  $
    S -> (L) | a \
    L -> L , S | S
  $
  + 试写出一个语法制导定义，它输出配对括号个数;
  + 写一个翻译方案，打印每个a的嵌套深度。如((a),a),打印2,1。（思考：如果要求出a出现的次数，怎么办？）
]

#solution[
  1.
  #table(
    columns: (auto, 1fr),
    inset: 10pt,
    align: center,
    [产生式], [语法规则],
    [$S -> (L)$], [$S.h := L.h + 1$],
    [$S -> a$], [$S.h := 0$],
    [$L -> L_1 , S$], [$L.h := L_1.h + S.h$],
    [$L->S$], [$L.h := S.h$],
    [$S' -> S$], [$"print"(S.h)$],
  )

  2.
  $
    S'->{S.d:=0;}S \
    S -> ({L.d := S.d + 1} L) \
    S -> a {"print"(S.d)} \
    L -> {L_1.d := L.d} L_1 , {S.d := L.d}S \
    L -> {S.d := L.d} S
  $
]