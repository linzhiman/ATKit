import os
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
                all_set.add('0x' + line_string_l)
            if len(line_string_r) > 0:
                all_set.add('0x' + line_string_r)
    return all_set


def do(object_file_path):
    all_class_set = get_data_set('otool -s __DATA __objc_classlist %s' % object_file_path)
    print((all_class_set))
    all_class_ref_set = get_data_set('otool -s __DATA __objc_classrefs %s' % object_file_path)
    print((all_class_ref_set))
    all_class_unused_set = all_class_set.difference(all_class_ref_set)
    print(len(all_class_unused_set))
    print(all_class_unused_set)

do('./ATKitDemo')
