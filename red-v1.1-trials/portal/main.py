import libvirt
import xml.etree.ElementTree as ET
import spice
import time

LIBVIRT_URI = "qemu:///system"
VM_NAME = "your-vm-name"


def get_spice_info(dom):
    xml = dom.XMLDesc(0)
    root = ET.fromstring(xml)

    for graphics in root.findall('devices/graphics'):
        if graphics.get('type') == 'spice':
            port = graphics.get('port')
            return "127.0.0.1", int(port)  # Default to localhost - may need adjustment if you use a remote libvirt server
    return None, None


try:
    conn = libvirt.open(LIBVIRT_URI)
    if not conn:
        print("Failed to connect to libvirt")
        exit(1)

    dom = conn.lookupByName(VM_NAME)
    if not dom:
        print("Failed to find VM")
        conn.close()
        exit(1)

    host, port = get_spice_info(dom)

    if host is None or port is None:
       print("Spice graphics not configured for this VM")
       conn.close()
       exit(1)

    print(f"Connecting to Spice {host}:{port}")


    # Initialize and connect to the SPICE server
    client = spice.Session()
    client.connect(f"spice://{host}:{port}")

    if not client.is_connected():
       print("Failed to connect to the SPICE server")
       conn.close()
       exit(1)
    # Wait for connection
    time.sleep(1)

    # Send Mouse events (Example)
    mouse = client.inputs.mouse
    mouse.move(100, 100)
    time.sleep(1)
    mouse.button_press(1) # left button
    mouse.button_release(1)
    time.sleep(1)
    client.disconnect()
    conn.close()
    print("Sent mouse events")

except libvirt.libvirtError as e:
    print(f"Libvirt error: {e}")
except spice.SpiceError as e:
      print(f"Spice error: {e}")
except Exception as e:
    print(f"An error occurred: {e}")


# virsh -c qemu:///system sendkey my-vm a
