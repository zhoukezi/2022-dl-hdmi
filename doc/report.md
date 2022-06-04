---
title: HDMI显示实验报告
author: 周嘉豪
date: 2022-06-03

papersize: A4
mainfont: Times New Roman
CJKmainfont: SimSun
CJKoptions: AutoFakeBold, AutoFakeSlant
fontsize: 12pt
numbersections: false
lang: zh-CN
babel-lang: chinese-simplified
header-includes:
  - \usepackage{indentfirst}
  - \setlength{\parindent}{2em}
  - \usepackage{hanging}
---

# 调试日志

## 2022-06-02

对照参考实现纠正了主要框架中的错误。

## 2022-06-03

对照参考实现纠正译码器中的一个错误，发现屏幕出现像素点显示问题，怀疑译码器中还有错误。

## 2022-06-04

像素点显示问题消失，原因不明。译码器中确实存在问题，但似乎没有造成可观察的异常。奇怪。

# 心得

本次实验是在验收前一周临时起意快速赶工出来的，时间紧任务重，导致出现了数量众多的低级错误，例如寄存器书写错误，敏感信号表意外多写了一个变量导致异步逻辑，PLL参数填错等。同时我也意识到完全按照书写软件的方式设计硬件是行不通的。软件编译快速，调试方便，编码-测试循环可以非常紧凑，因此通常可以在开发前期快速构建框架，在后期调试时统一处理问题。硬件设计时，编译和下载速度慢于软件编译，且硬件整体调试难度高于软件：使用硬件实现的算法或协议本身通常较复杂，硬件抽象层次低，调试时难以理解，片上调试较复杂。设计硬件时，应当在设计的同时便充分验证每一个组件的功能，不将问题积累到最后阶段，否则将难以处理。
