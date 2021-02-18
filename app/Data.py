#coding=UTF-8
import pygal
import time
import re
import os,xlrd,csv

class Data(object):
    def get_ping_data(self, ping_data_file):
        ping_data = open(ping_data_file).read()
        #ping_data = ping_data.encode('utf-8')
        reg_receive = 'time=\d+\.\d+ ms'
        match = re.findall(reg_receive, ping_data)
        ping_list = []
        for i in match:
            ping_list.append(i[5:-3])
        print(ping_list)
        #res='{0}={1}'.format(ping_name,ping_list)
        return ping_list

    def get_iperf_data(self,iperf_data):
        iperf_data = iperf_data.encode('utf-8').split('\n')
        iperf_list = []
        for element in iperf_data:
            if  'Mbits/sec' in element:
                reg_receive_Mb = '\d+\.\d+ Mbits/sec'
                match_Mb = re.search(reg_receive_Mb, element).group()
                iperf_list.append(match_Mb[0:-10])
            elif  'Kbits/sec' in element:
                reg_receive_Kb = '\d+ Kbits/sec'
                match_Kb=re.search(reg_receive_Kb, element).group()
                i=int(match_Kb[0:-10])
                iperf_speed=format(float(i)/float(1024),'.3f')
                iperf_list.append(iperf_speed)
            else:
                pass
        return iperf_list

    def get_file_data(self, file):
        data_dic={}
        if "excel" in file or "xlsx" in file or "xls" in file:
            workbook = xlrd.open_workbook(file)
            sheet = workbook.sheet_by_index(0)
            ncols = sheet.ncols
            print(ncols,type(ncols))
            for i in range(ncols):
                cols = sheet.col_values(i)
                k = cols[0]
                del cols[0]
                v = list(map(float, cols))
                data_dic[k] = v
        elif "csv" in file:
            with open(file, encoding='utf-8') as f:
                reader = csv.reader(f)
                header = next(reader)
                print(reader)
                print(reader,type(reader))

                for index,info in enumerate(reader):
                    for i in range(len(header)):
                        if header[i] not in data_dic.keys():
                            data_dic[header[i]] = []
                        else:
                            data_dic[header[i]].append(float(info[i]))        
        return data_dic

    def data_net_draw(self, type, **kwargs):
        line_chart = pygal.Line()
        alist=[]
        for key, value in kwargs.items():
            alist.append(len(value))
        x=max(alist)
        line_chart.x_labels = map(str, range(0, x))
        if type == 'ping':
            title = 'ping 结果 单位：ms'
        else:
            title = 'iperf 结果 单位：Mbits/sec'
        for key, value in kwargs.items():
            line_chart.title = title
            line_chart.add(key, list(map(float, value)))
        loacl_time=time.strftime("%Y-%m-%d-%H-%M-%S", time.localtime())
        name = type + '-'+ loacl_time + '.svg'
        file = 'static/' + name
        line_chart.render_to_file(file)
        return name

    def data_draw(self, **kwargs):
        line_chart = pygal.Line()
        alist=[]
        for key, value in kwargs.items():
            alist.append(len(value))
        x=max(alist)
        line_chart.x_labels = map(str, range(0, x))
        for key, value in kwargs.items():
            line_chart.add(key, list(map(float, value)))
        loacl_time=time.strftime("%Y-%m-%d-%H-%M-%S", time.localtime())
        name = loacl_time + '.svg'
        file = 'static/' + name
        line_chart.render_to_file(file)
        return name

if __name__ == '__main__':
    a=Data()
    data=a.get_file_data("receive/1.csv")
    print(data)
    