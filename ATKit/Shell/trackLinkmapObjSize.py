import os
import re
import subprocess


def write_html_begin(version):
    if not os.path.exists('./trackLinkmapObjSize/'):
        os.mkdir('./trackLinkmapObjSize/')
    html_file_path = './trackLinkmapObjSize/trackLinkmapObjSize%s.html' % version
    file = open(html_file_path, 'w+')
    file.write('<html><meta http-equiv="Content-Type" content="text/html; charset=utf-8">')
    file.write('<head><title>trackLinkmapObjSize</title></head><body>')
    return file


def write_html_end(file, version):
    html_file_path = './trackLinkmapObjSize/trackLinkmapObjSize%s.html' % version
    file.write('</body></html>')
    file.close()
    subprocess.call(['open', html_file_path])


def write_html_table(file, title, name_size_list):
    file.write('<p></p>')
    file.write('<table border = "1"><tr><td> %s </td><td> %s </td></tr>' % (title, 'byte'))
    for (path, size) in name_size_list:
        file.write('<tr><td> %s </td><td> %d </td></tr>' % (path, size))
    file.write('</table>')


def do(linkmap_file_path, version):
    try:
        file = open(linkmap_file_path, "r")
        file_lines = file.readlines()
        file.close()

        index_name_dic = {}
        index_size_dic = {}

        # [  0] linker synthesized
        rule_object_files = r'^\[\s*(\d+)\]\s+(.+)'

        # 0x100004EC0	0x00000092	[  4] _main
        rule_symbols = r'^.+\s+(0x\w+)\s+\[\s*(\d+)\]\s+(.+)'

        is_object_files = False
        is_sections = False
        is_symbols = False
        for line in file_lines:
            line = line.replace('\n', '')
            if line == '# Object files:':
                is_object_files = True
                continue
            if line == '# Sections:':
                is_sections = True
                continue
            if line == '# Symbols:':
                is_symbols = True
                continue
            if is_symbols:
                match_obj = re.match(rule_symbols, line)
                if match_obj:
                    symbols_size = int(match_obj.group(1), 16)
                    index_size_dic[match_obj.group(2)] += symbols_size
            elif is_sections:
                continue
            elif is_object_files:
                match_obj = re.match(rule_object_files, line)
                if match_obj:
                    object_path = match_obj.group(2)
                    object_path = object_path[object_path.rfind('/')+1:len(object_path)]
                    index_name_dic[match_obj.group(1)] = object_path
                    index_size_dic[match_obj.group(1)] = 0

        name_size_dic = {}
        for index, size in index_size_dic.items():
            name_size_dic[index_name_dic[index]] = size

        # libATKit.a(ATNotificationUtils.o)
        rule_group = r'(.+)\((.+)\)'

        result_group_size_dic = {}
        result_group_name_size_dic = {}
        for name, size in name_size_dic.items():
            match_obj = re.match(rule_group, name)
            if match_obj:
                group_name = match_obj.group(1)
                result_group_size_dic[group_name] = result_group_size_dic.get(group_name, 0) + size
                result_group = result_group_name_size_dic.get(group_name, {})
                result_group[match_obj.group(2)] = size
                result_group_name_size_dic[group_name] = result_group
            else:
                result_group_size_dic[name] = size

        result_group_size_list = sorted(result_group_size_dic.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
        file = write_html_begin(version)
        write_html_table(file, 'object', result_group_size_list)
        for group_name, group_name_size_dic in result_group_name_size_dic.items():
            group_name_size_list = sorted(group_name_size_dic.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
            write_html_table(file, group_name, group_name_size_list)
        write_html_end(file, version)

    except Exception as e:
        print(linkmap_file_path + ":" + e.__str__())


do('./linkmap.txt', '1.0.0')
