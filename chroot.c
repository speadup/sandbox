#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <signal.h> 
#include <getopt.h>
#include <errno.h>
#include <sys/file.h>
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

int isbind(const char *path)
{
    int fd = open(path, O_RDONLY);
    if(fd == -1)
        return -1;
    if(flock(fd, LOCK_SH) == -1){
        return -1;
    }
    if(umount(path) == -1 && errno == EBUSY) {
        close(fd);
        return 0;
    }
    close(fd);
    return 1;
}

int do_mount(const char* dev, const char *path, const char *type, unsigned long flag)
{
    printf("mount %s ... ", path);
    if(mountpoint(path) == 0 || isbind(path) == 0) {
        printf("mounted.\n");
        return 1;
    } 
    if(mount(dev, path, type, flag, NULL) == 0) {
        printf("ok.\n");
        return 0;
    }
    printf("fail:%d.\n", errno);
    return -1;
}

int do_unmount(const char *path)
{
    printf("unmount %s ... \n", path);
    if(mountpoint(path) == 0) {
        if(umount(path) == 0){
            printf("ok.\n");
            return 0;
        }
        printf("fail:%d.\n", errno);
        return -1;
    }
    printf("invalid.\n");
    return -1;
}

int main(int argc, char *argv[])
{
    int opt = 0;
    int pid = 0;
    int uid = 500;
    int gid = 0;
    int status = 0;
    int i = 0;
    char *root = NULL;
    char *bind = NULL;
    char buff[PATH_MAX];
    const char *short_options = "b:g:u:";
    const struct option long_options[] = {
        {"bind", required_argument, NULL, 'b'},
        {"gid",  required_argument, NULL, 'g'},
        {"uid",  required_argument, NULL, 'u'},
        {NULL, 0, NULL, 0},
    };
    while((opt = getopt_long(argc, argv, short_options, long_options, NULL)) != -1)
    {
        switch(opt) {
        case 'b':
            bind = optarg;
        case 'g':
            gid = atoi(optarg);
            break;
        case 'u':
            uid = atoi(optarg);
            break;
        case '?':
                 printf("Unknown option -%c\n\n", optopt);
                 exit(1);
        default:
                 printf("What happened?\n\n");
                 exit(1);
        }
    }
    setgroups(0, NULL);
    setgid(0);
    setuid(0);
    if(optind >= argc) {
        root = ".";
    } else {
        root = argv[optind];
        optind++;
    }
    if(bind && *bind) {
        snprintf(buff, PATH_MAX, "%s/work", root);
        do_mount(bind, buff, "none", MS_BIND);
    }
    printf("chroot %s ... ", root);
    if(chroot(root) == -1) {
        printf("fail:%d.\n", errno);
        return 0;
    }
    printf("ok.\n");
    do_mount(NULL, "/proc",    "proc",   0);
    do_mount(NULL, "/sys",     "sysfs",  0);
    do_mount(NULL, "/dev/pts", "devpts", 0);
    do_mount(NULL, "/dev/shm", "tmpfs",  0);

    setgroups(0, NULL);
    setgid(gid);
    setuid(uid);
    if(uid == 0) {
        chdir("/root");
    } else {
        chdir("/home/compile");
    }

    char *params[32] = {0};
    if(optind >= argc){
        params[0] = "-bash";
        params[1] = NULL;
    } else {
        if(argc - optind >= 32) {
            printf("options too many!");
            return 1;
        }
        for(i = 0; i < argc - optind; i++){
            params[i] = argv[optind + i];
        }
        params[i] = NULL;
    }
    char *env[] = {
        "shell=bash",
        "TERM=xterm",
        "HOME=/home/compile",
        "USER=compile",
        "LOGNAME=compile",
        "SHELL=/bin/bash",
        "LANG=en_US.UTF-8",
        NULL};
    if(uid == 0) {
        env[1] = "HOME=/root";
        env[2] = "USER=root";
        env[3] = "LOGNAME=root";
    }
    execve("/bin/bash", params, env);
    printf("exit:%d\n", errno);

    return 0;
}
