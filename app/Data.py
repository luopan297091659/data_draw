#coding=UTF-8
import pygal
import time
import re
import os


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

    def data_draw(self, type, **kwargs):
        line_chart = pygal.Line()
        alist=[]
        for key, value in kwargs.items():
            alist.append(len(value))
        x=max(alist)
        line_chart.x_labels = map(str, range(0, x))
        if type is 'ping':
            title = 'ping 结果 单位：ms'
        else:
            title = 'iperf 结果 单位：Mbits/sec'
        for key, value in kwargs.items():
            line_chart.title = title
            line_chart.add(key, list(map(float, value)))
        loacl_time=time.strftime("%Y-%m-%d-%H-%M-%S", time.localtime())
        name = type + '-'+ loacl_time + '.svg'
        file = 'static/' + name
        line_chart.render_to_file(name)
        '''
        logfile = BuiltIn().get_variable_value('${LOG FILE}')
        log_dir=os.path.dirname(logfile)
        logger.info('</td></tr><tr><td colspan="3">'
                  '<a href="{src}"><img src="{src}" width="1200px"></a>'
                    .format(src=get_link_path(path, log_dir)), html=True)
'''
        return name


if __name__ == '__main__':
    a=Data()
    data=a.get_ping_data("1.txt")
    a.data_draw("ping", a=data)
    