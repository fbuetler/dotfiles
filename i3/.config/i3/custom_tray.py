import gi
import subprocess
import os

gi.require_version("Gtk", "3.0")
gi.require_version("AppIndicator3", "0.1")

from gi.repository import Gtk as gtk
from gi.repository import AppIndicator3 as appindicator


def main():
    indicator = appindicator.Indicator.new(
        "custom_tray",
        "semi-starred-symbolic",
        appindicator.IndicatorCategory.APPLICATION_STATUS,
    )
    indicator.set_status(appindicator.IndicatorStatus.ACTIVE)
    indicator.set_menu(menu())
    gtk.main()


def menu():
    menu = gtk.Menu()

    command_one = gtk.MenuItem(label="Notes")
    command_one.connect("activate", note)
    menu.append(command_one)

    exittray = gtk.MenuItem(label="Exit")
    exittray.connect("activate", quit)
    menu.append(exittray)

    menu.show_all()
    return menu


def note(_):
    subprocess.call(("vim", "/tmp/notes.txt"))


def quit(_):
    gtk.main_quit()


if __name__ == "__main__":
    main()
