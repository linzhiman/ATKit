import os
import json
import subprocess


def get_file_size(file_path):
    try:
        return os.path.getsize(file_path)
    except Exception as err:
        print(err)
    return -1


def get_all_image_path_size(file_dir, dic_path_size, exclude_dir_list):
    for file in os.listdir(file_dir):
        if file in exclude_dir_list:
            continue
        file_path = os.path.join(file_dir, file)
        if os.path.isdir(file_path):
            get_all_image_path_size(file_path, dic_path_size, exclude_dir_list)
        elif file_path.endswith('.png'):
            dic_path_size[file_path] = get_file_size(file_path)


def save_dic_to_json(path_size_dic, cur_version):
    json_file_path = './trackImageSize/trackImageSize%s.json' % cur_version
    with open(json_file_path, 'w', encoding='utf-8') as f:
        json.dump(path_size_dic, f)


def get_dic_from_json(pre_version):
    json_file_path = './trackImageSize/trackImageSize%s.json' % pre_version
    if not os.path.exists(json_file_path):
        return
    with open(json_file_path, 'r', encoding='utf-8') as f:
        file_content = f.read()
        res = json.loads(file_content)
        return res


def get_dic_value_sum(path_size_list):
    size_sum = 0
    for (path, size) in path_size_list:
        size_sum = size_sum + size
    return size_sum


def write_list(file, path_size_list, title, top_count):
    file.write('<p></p>')
    file.write('<table border = "1"><tr><td> %s </td><td> %s </td></tr>' % (title, 'byte'))
    index = 0
    for (path, size) in path_size_list:
        index += 1;
        if index <= top_count:
            file.write('<tr style="background-color:rgb(180,220,16)"><td> %s </td><td> %d </td></tr>' % (path, size))
        else:
            file.write('<tr><td> %s </td><td> %d </td></tr>' % (path, size))
    file.write('</table>')


def save_list_to_html(path_size_list, add_list, remove_list, change_list, version):
    html_file_path = './trackImageSize/trackImageSize%s.html' % version
    file = open(html_file_path, 'w+')
    file.write('<html><meta http-equiv="Content-Type" content="text/html; charset=utf-8">')
    file.write('<head><title>trackImageSize</title></head><body>')
    file.write('<table border = "1"><tr><td> %s </td><td> %s </td></tr>' % ('size change type', 'byte'))
    add_sum = get_dic_value_sum(add_list)
    remove_sum = get_dic_value_sum(remove_list)
    change_sum = get_dic_value_sum(change_list)
    file.write('<tr><td> %s </td><td> %d </td></tr>' % ('all', add_sum - remove_sum + change_sum))
    file.write('<tr><td> %s </td><td> %d </td></tr>' % ('add', add_sum))
    file.write('<tr><td> %s </td><td> %d </td></tr>' % ('remove', remove_sum))
    file.write('<tr><td> %s </td><td> %d </td></tr>' % ('change', change_sum))
    file.write('</table>')
    write_list(file, add_list, 'added image path', 0)
    write_list(file, remove_list, 'removed image path', 0)
    write_list(file, change_list, 'changed image path', 0)
    write_list(file, path_size_list, 'current version image path', 10)
    file.write('</body></html>')
    file.close()
    subprocess.call(['open', html_file_path])


def do(root_dir, exclude_dir_list, cur_version, pre_version):
    if not os.path.exists('./trackImageSize/'):
        os.mkdir('./trackImageSize/')

    all_size_dic = {}
    get_all_image_path_size(root_dir, all_size_dic, exclude_dir_list)

    save_dic_to_json(all_size_dic, cur_version)
    pre_all_size_dic = get_dic_from_json(pre_version)

    add_dic = {}
    remove_dic = {}
    change_dic = {}
    if pre_all_size_dic is not None:
        for path, size in pre_all_size_dic.items():
            if path in all_size_dic:
                if size != all_size_dic[path]:
                    change_dic[path] = all_size_dic[path] - size
            else:
                remove_dic[path] = size
        for path, size in all_size_dic.items():
            if path not in pre_all_size_dic:
                add_dic[path] = size

    all_size_list = sorted(all_size_dic.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
    add_list = sorted(add_dic.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
    remove_list = sorted(remove_dic.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
    change_list = sorted(change_dic.items(), key=lambda kv: (kv[1], kv[0]), reverse=True)
    save_list_to_html(all_size_list, add_list, remove_list, change_list, cur_version)


do('../', ['Pods'], '1.1.0', '1.0.0')
