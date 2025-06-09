import win32serviceutil
import win32service
import win32event
import servicemanager
import subprocess
import os

class MyService(win32serviceutil.ServiceFramework):
    _svc_name_ = "MyPythonAPIService"
    _svc_display_name_ = "FAAV SERVER"

    def __init__(self, args):
        win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        self.process = None

    def SvcStop(self):
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        if self.process:
            self.process.terminate()
        win32event.SetEvent(self.hWaitStop)

    def SvcDoRun(self):
        servicemanager.LogInfoMsg("My Python API Service is starting...")
        script_path = os.path.abspath("RTSP_Live_streaming.py")
        self.process = subprocess.Popen(["python", script_path])
        win32event.WaitForSingleObject(self.hWaitStop, win32event.INFINITE)

if __name__ == '__main__':
    win32serviceutil.HandleCommandLine(MyService)
