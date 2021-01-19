# coding:utf-8

import os
import sys
import shutil

def exec_build(srcdir):
    if not os.path.isdir(srcdir):
        print("srcdir is none,please enter correct path\n")
        return

    cmdlines = ""
    items = os.listdir(srcdir)  # 列出文件夹下所有的目录与文件
    for item in items:
        fullpath = os.path.join(srcdir, item)
        if os.path.isfile(fullpath) and fullpath.endswith(".v"):
            cmdlines = cmdlines + " " + item + " "

    build_out_dir = os.path.dirname(srcdir) + "\\build\\build_out"
    if not os.path.isdir(build_out_dir):
        os.makedirs(build_out_dir)

    os.chdir(srcdir)

    # step1 exec iverilog.exe
    exe_cmd = "iverilog.exe -o " + "..\\build\\build_out\\a.out" + " -i " + cmdlines
    print("\n-------->exec cmd:" + exe_cmd + "")
    os.system(exe_cmd)

    exe_cmd = "dir /b ..\\build\\build_out"
    print("-------->生成如下文件:")
    os.system(exe_cmd)

    # step2 exec vvp

    # step3 exec gtkwave


def exec_build_2():
    cur_path = os.path.abspath(sys.argv[0])
    build_py = os.path.dirname(cur_path)
    build_dir = os.path.dirname(build_py)
    module_dir = os.path.dirname(build_dir)
    rtl_dir = module_dir + "\\" + "rtl"
    tb_dir = module_dir + "\\" + "tb"

    rtl_srcs = ""
    rtl_srcs_shows = "+++++++++>"
    rtl_items = os.listdir(rtl_dir)  # 列出文件夹下所有的目录与文件
    for item in rtl_items:
        fullpath = os.path.join(rtl_dir, item)
        if os.path.isfile(fullpath) and fullpath.endswith(".v"):
            rtl_srcs = rtl_srcs + fullpath + " "
            rtl_srcs_shows = rtl_srcs_shows + item + "\n+++++++++>"

    tb_srcs = ""
    tb_srcs_shows = ""
    tb_items = os.listdir(tb_dir)  # 列出文件夹下所有的目录与文件
    for item in tb_items:
        fullpath = os.path.join(tb_dir, item)
        if os.path.isfile(fullpath) and fullpath.endswith(".v"):
            tb_srcs = tb_srcs + fullpath + " "
            tb_srcs_shows = tb_srcs_shows + item + "\n+++++++++>"

    tb_srcs_shows = tb_srcs_shows + "end!"

    build_out = build_dir + "\\build_out"
    if not os.path.isdir(build_out):
        os.makedirs(build_out)

    os.chdir(module_dir)

    #step1 exec iverilog.exe
    v_files = rtl_srcs + " " + tb_srcs
    exe_cmd = "iverilog.exe -o " + build_out + "\\a.out" + " -i " + v_files
    os.system(exe_cmd)
    print("\n-------->iverilog.exe compile those v files:\n" + rtl_srcs_shows + tb_srcs_shows)

    print("-------->当前目录如下:")
    exe_cmd = "dir /b .\\build\\build_out"
    os.system(exe_cmd)

    # step2 exec vvp
    a_out = build_dir+"\\build_out\\a.out"
    if not os.path.isfile(a_out):
        print("a_out don't exist\n")
        return

    exe_cmd = "vvp -n " + a_out
    os.system(exe_cmd)

    wave_vcd = module_dir+"\\wave.vcd"
    if not os.path.isfile(wave_vcd):
        print("-------->failed:" + exe_cmd)
        return

    print("-------->success:" + exe_cmd)

    wave_vcd_build = build_out+"\\wave.vcd"
    if os.path.isfile(wave_vcd_build):
        os.remove(wave_vcd_build)

    shutil.move(wave_vcd, wave_vcd_build)

    # step3 exec gtkwave
    exe_cmd = "gtkwave.exe " + wave_vcd_build
    print("-------->" + exe_cmd)
    os.system(exe_cmd)


# print(sys.argv[1])
# exec_build(sys.argv[1])

exec_build_2()
