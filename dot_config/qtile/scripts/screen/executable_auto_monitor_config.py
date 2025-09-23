#!/usr/bin/env python3
"""
Auto-monitor detection script for Qtile
Automatically configures new displays to the right of primary screen
"""

import subprocess
import time
import re
import os
import signal
import sys
from threading import Thread

class MonitorManager:
    def __init__(self):
        self.previous_displays = set()
        self.primary_display = None
        self.running = True
        
    def get_connected_displays(self):
        """Get list of currently connected displays"""
        try:
            result = subprocess.run(['xrandr'], capture_output=True, text=True)
            displays = []
            
            for line in result.stdout.split('\n'):
                if ' connected' in line:
                    display_name = line.split()[0]
                    displays.append(display_name)
                    
                    # Check if this is primary
                    if 'primary' in line:
                        self.primary_display = display_name
                        
            return set(displays)
        except Exception as e:
            print(f"Error getting displays: {e}")
            return set()
    
    def get_display_resolution(self, display):
        """Get the preferred resolution for a display"""
        try:
            result = subprocess.run(['xrandr'], capture_output=True, text=True)
            
            for line in result.stdout.split('\n'):
                if display in line and ' connected' in line:
                    # Look for resolution in the next lines
                    lines = result.stdout.split('\n')
                    display_index = lines.index(line)
                    
                    for i in range(display_index + 1, len(lines)):
                        if lines[i].startswith('   ') and 'x' in lines[i]:
                            # Extract resolution (first one should be preferred)
                            resolution = lines[i].strip().split()[0]
                            return resolution
                        elif not lines[i].startswith('   '):
                            break
                            
            return "1920x1080"  # fallback
        except Exception as e:
            print(f"Error getting resolution for {display}: {e}")
            return "1920x1080"
    
    def configure_display(self, new_display):
        """Configure new display to the right of primary"""
        if not self.primary_display:
            print("No primary display found")
            return False
            
        try:
            # Get resolution for the new display
            resolution = self.get_display_resolution(new_display)
            
            # Configure the new display to the right of primary
            cmd = [
                'xrandr',
                '--output', new_display,
                '--mode', resolution,
                '--right-of', self.primary_display,
                '--auto'
            ]
            
            print(f"Configuring {new_display} ({resolution}) to right of {self.primary_display}")
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"Successfully configured {new_display}")
                self.restart_qtile()
                return True
            else:
                print(f"Error configuring display: {result.stderr}")
                return False
                
        except Exception as e:
            print(f"Error configuring display {new_display}: {e}")
            return False
    
    def restart_qtile(self):
        """Restart Qtile to recognize new screen configuration"""
        try:
            # Send restart command to Qtile
            subprocess.run(['qtile', 'cmd-obj', '-o', 'cmd', '-f', 'restart'])
            print("Qtile restarted to recognize new display configuration")
        except Exception as e:
            print(f"Error restarting Qtile: {e}")
    
    def monitor_displays(self):
        """Main monitoring loop"""
        print("Starting display monitor...")
        self.previous_displays = self.get_connected_displays()
        print(f"Initial displays: {self.previous_displays}")
        
        while self.running:
            try:
                current_displays = self.get_connected_displays()
                
                # Check for new displays
                new_displays = current_displays - self.previous_displays
                removed_displays = self.previous_displays - current_displays
                
                if new_displays:
                    print(f"New display(s) detected: {new_displays}")
                    for display in new_displays:
                        if display != self.primary_display:
                            self.configure_display(display)
                
                if removed_displays:
                    print(f"Display(s) removed: {removed_displays}")
                    # Optionally restart Qtile when displays are removed
                    self.restart_qtile()
                
                self.previous_displays = current_displays
                time.sleep(2)  # Check every 2 seconds
                
            except KeyboardInterrupt:
                break
            except Exception as e:
                print(f"Error in monitoring loop: {e}")
                time.sleep(5)
    
    def stop(self):
        """Stop the monitoring"""
        self.running = False

def signal_handler(signum, frame):
    """Handle shutdown signals gracefully"""
    print("\nShutting down monitor...")
    monitor.stop()
    sys.exit(0)

def run_as_daemon():
    """Run the script as a daemon process"""
    try:
        pid = os.fork()
        if pid > 0:
            # Parent process
            print(f"Monitor started as daemon with PID: {pid}")
            sys.exit(0)
    except OSError as e:
        print(f"Fork failed: {e}")
        sys.exit(1)
    
    # Child process continues as daemon
    os.chdir('/')
    os.setsid()
    os.umask(0)

if __name__ == "__main__":
    # Set up signal handlers
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    # Check if should run as daemon
    daemon_mode = '--daemon' in sys.argv
    
    if daemon_mode:
        run_as_daemon()
    
    # Create and start monitor
    monitor = MonitorManager()
    
    try:
        monitor.monitor_displays()
    except KeyboardInterrupt:
        print("\nMonitor stopped by user")
    except Exception as e:
        print(f"Monitor crashed: {e}")
    finally:
        monitor.stop()
