import socket, time

ip = "login.darknaught.com"
port = 44455

class Servername:
    def __init__(self, name):
        self.name = name

    def setName(self, name):
        self.name = name

    def getName(self):
        return self.name

class ServerStatus:
    def main(self):
        Servername.setName(self, self.get_status(ip, port).split('<name>')[1].split('</name>')[0])

        while True:
            try:
                data = self.get_status(ip, port)

                name = data.split('<name>')[1].split('</name>')[0]
                status = data.split('<status>')[1].split('</status>')[0]
                connected = data.split('<connected>')[1].split('</connected>')[0]
                cap = data.split('<cap>')[1].split('</cap>')[0]
                max = data.split('<max>')[1].split('</max>')[0]
                total = data.split('<total>')[1].split('</total>')[0]
                deleted = data.split('<deleted>')[1].split('</deleted>')[0]
                uptime = data.split('<uptime>')[1].split('</uptime>')[0]
                timestamp = data.split('<timestamp>')[1].split('</timestamp>')[0]
                
                if status == "up":
                    status = "online"

                retStr = '''{
    "name": "%s",
    "status": "%s",
    "connected": %s,
    "cap": %s,
    "max": %s,
    "total": %s,
    "deleted": %s,
    "uptime": %s,
    "timestamp": %s
}'''%(name, status, connected, cap, max, total, deleted, uptime, timestamp)

                if (len(status.strip()) != 0):
                    file = open("status.json", "w")
                    file.write(retStr)

                time.sleep(5)
            except:
                retStr = '''{
    "name": "%s",
    "status": "offline",
    "connected": 0,
    "cap": 0,
    "max": 0,
    "total": 0,
    "deleted": 0,
    "uptime": 0,
    "timestamp": 0
}'''%(Servername.getName(self))

                file = open("status.json", "w")
                file.write(retStr)

                time.sleep(5)


    def get_status(self, TCP_IP, TCP_PORT):
        BUFFER_SIZE=1024

        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.connect((TCP_IP, TCP_PORT))
        data = s.recv(BUFFER_SIZE)
        s.close()

        return data.decode('utf-8')

if __name__ == "__main__":
    status = ServerStatus()
    status.main()
