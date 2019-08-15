import os
import re
import subprocess


def get_data_set(command):
    all_lines = subprocess.getoutput(command)
    all_lines = all_lines.splitlines()
    all_set = set()
    for line in all_lines:
        if line.find('\t') != -1:
            # '0000000100014c28\t68 a5 01 00 01 00 00 00 e0 a5 01 00 01 00 00 00 '
            line = line[line.find('\t') + 1: len(line)]
            line_items = line.strip().split(' ')
            # ['68', 'a5', '01', '00', '01', '00', '00', '00', 'e0', 'a5', '01', '00', '01', '00', '00', '00']
            # 10001a568 10001a5e0
            line_string_l = ''
            line_string_r = ''
            line_string_length = len(line_items) // 2
            line_string_l_index = line_string_length - 1
            line_string_r_index = len(line_items) - 1
            for index in range(line_string_length):
                line_string_l = line_string_l + line_items[line_string_l_index - index]
                line_string_r = line_string_r + line_items[line_string_r_index - index]
            line_string_l = line_string_l.lstrip('0')
            line_string_r = line_string_r.lstrip('0')
            if len(line_string_l) > 0:
                all_set.add(line_string_l)
            if len(line_string_r) > 0:
                all_set.add(line_string_r)
    return all_set


def get_name_dic(command, out_all_name_dic, out_all_super_dic):
    # Contents of (__DATA,__objc_classlist) section
    # 0000000100014c28 0x10001a568 _OBJC_CLASS_$_ATKitTransformViewController
    # ...
    #     superclass 0x0 _OBJC_CLASS_$_NSObject
    # ...
    # Contents of (__DATA,__objc_classrefs) section
    # 000000010001a2d8 0x0 _OBJC_CLASS_$_UIButton
    all_lines = subprocess.getoutput(command)
    all_lines = all_lines.splitlines()
    rule_classlist = r'^\w+\s0x(\w+)\s_OBJC_CLASS_\$_(.+)'
    rule_superclass = r'^    superclass 0x(\w+) _OBJC_CLASS_\$_(.+)'
    is_in_classlist = False
    last_class_find_super = ''
    for line in all_lines:
        if line == 'Contents of (__DATA,__objc_classlist) section':
            is_in_classlist = True
        elif line == 'Contents of (__DATA,__objc_classrefs) section':
            is_in_classlist = False
            break
        if is_in_classlist:
            match_obj = re.match(rule_classlist, line)
            if match_obj:
                out_all_name_dic[match_obj.group(1)] = match_obj.group(2)
                last_class_find_super = match_obj.group(1)
            else:
                match_obj = re.match(rule_superclass, line)
                if match_obj:
                    if len(last_class_find_super) > 0:
                        if match_obj.group(1) != '0':
                            out_all_super_dic[last_class_find_super] = match_obj.group(1)
                        last_class_find_super = ''


def do(object_file_path):
    all_class_name_dic = {}
    all_class_super_dic = {}
    get_name_dic('otool -o -v %s' % object_file_path, all_class_name_dic, all_class_super_dic)
    print(all_class_name_dic)
    print(all_class_super_dic)

    all_class_ref_set = get_data_set('otool -s __DATA __objc_classrefs %s' % object_file_path)
    all_class_super_ref_set = set()
    for class_ref in all_class_ref_set:
        tmp_class_ref = class_ref
        while tmp_class_ref in all_class_super_dic:
            tmp_class_ref = all_class_super_dic[tmp_class_ref]
            all_class_super_ref_set.add(tmp_class_ref)
    print(all_class_ref_set)
    print(all_class_super_ref_set)
    all_class_ref_set = all_class_ref_set.union(all_class_super_ref_set)

    all_class_set = get_data_set('otool -s __DATA __objc_classlist %s' % object_file_path)
    print(all_class_set)

    all_class_unused_set = all_class_set.difference(all_class_ref_set)
    print(len(all_class_unused_set))
    print(all_class_unused_set)

    all_unused_name_list = []
    for key in all_class_unused_set:
        all_unused_name_list.append(all_class_name_dic[key])
    print(all_unused_name_list)

do('./ATKitDemo')
