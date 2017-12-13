#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <signal.h> 
#include <sys/mount.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <linux/limits.h>
#include <unistd.h>
#include <grp.h>

int mountpoint(const char *path)
{
    struct stat st;
    char buff[PATH_MAX];
    if(lstat(path, &st) != 0)
        return -1;

    if (S_ISDIR(st.st_mode)) {
        dev_t st_dev = st.st_dev;
        ino_t st_ino = st.st_ino;
        snprintf(buff, PATH_MAX, "%s/..", path);

        if (stat(buff, &st) == 0)
            return (st_dev == st.st_dev) && (st_ino != st.st_ino);

    }
    return -2;
}

int do_mount(const char *path, const char *type)
{
    if(mountpoint(path) == 0) {
        printf("%s is mounted.\n", path);
        return 1;
    } else {
        if(mount("none", path, type, 0, NULL) != 0) {
            printf("%s mount fail!\n");
            return -1;
        }
        return 0;
    }

}

int do_unmount(const char *path)
{
    if(mountpoint(path) == 0) {
        if(umount(path) == 0){
            return 0;
        } else {
            printf("%s unmount fail!\n", path);
            return -1;
        }
    } else {
        printf("%s is not mounted.\n", path);
        return -1;
    }

}

int main(int argc, char *argv[])
{
    int pid = 0;
    int status = 0;
    signal_init();
    setgroups(0, NULL);
    setgid(0);
    setuid(0);
    if(argc >= 2)
        status = chroot(argv[1]);
    else
        status = chroot(".");
    printf("chroot=%d\n", status);
    if(status < 0)
        return;
    do_mount("/proc",    "proc");
    do_mount("/sys",     "sysfs");
    //do_mount("/dev",     "devtmpfs");
    do_mount("/dev/pts", "devpts");
    do_mount("/dev/shm", "tmpfs");

    if((pid = fork()) == 0){

        setgroups(0, NULL);
        setgid(0);
        setuid(500);
        chdir("/home/compile");

        char **params = NULL;
        int i = 0;
        if(argc > 2){
            params = malloc(sizeof(char *) * argc);
            for(i = 2; i < argc; i++){
                params[i-2] = argv[i];
            }
            params[argc -2] = NULL;
        } else {
            params = malloc(5);
            params[0] = "/bin/bash";
            params[1] = "-l";
            params[2] = "-c";
            params[3] = "exec /bin/bash";
            params[4] = NULL;
        }
        char *env[] = {"TERM=xterm", "HOME=/home/compile", "USER=compile", "LOGNAME=compile", "SHELL=/bin/bash", "LANG=posix.UTF-8", NULL};
        execve(params[0], params, env);
    } else {
        while(wait(NULL) < 0);
    }
    
    printf("exit\n");

    return 0;
}
