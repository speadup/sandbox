#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <signal.h> 
#include <getopt.h>
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
        if(mount(type, path, type, 0, NULL) != 0) {
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
    int opt = 0;
    int pid = 0;
    int uid = 500;
    int gid = 0;
    int status = 0;
    int i = 0;
    const char *short_options = "g:u:";
    const struct option long_options[] = {
        {"gid", required_argument, NULL, 'g'},
        {"uid", required_argument, NULL, 'u'},
        {NULL, 0, NULL, 0},
    };
    while((opt = getopt_long(argc, argv, short_options, long_options, NULL)) != -1)
    {
        switch(opt) {
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
#if 0
    printf("optind=%d, argc=%d\n", optind, argc);
    printf("uid=%d,gid=%d\n", uid, gid);
    for(i = 0; i < argc; i++) {
        printf("argv[%d]=%s\n", i, argv[i]);
    }
#endif
    setgroups(0, NULL);
    setgid(0);
    setuid(0);
    if(optind >= argc) {
        status = chroot(".");
    } else {
        status = chroot(argv[optind]);
        optind++;
    }
    printf("chroot=%d\n", status);
    if(status < 0)
        return 0;
    do_mount("/proc",    "proc");
    do_mount("/sys",     "sysfs");
    //do_mount("/dev",     "devtmpfs");
    do_mount("/dev/pts", "devpts");
    do_mount("/dev/shm", "tmpfs");

    setgroups(0, NULL);
    setgid(gid);
    setuid(uid);
    chdir("/home/compile");

    char **params = NULL;
    if(optind >= argc){
        params = malloc(5);
        params[0] = "/bin/bash";
        params[1] = "-l";
        params[2] = "-c";
        params[3] = "exec /bin/bash";
        params[4] = NULL;
    } else {
        params = malloc(sizeof(char *) * (argc - optind));
        for(i = 0; i < argc - optind; i++){
            params[i] = argv[optind + i];
        }
        params[i] = NULL;
    }
    char *env[] = {"TERM=xterm", "HOME=/home/compile", "USER=compile", "LOGNAME=compile", "SHELL=/bin/bash", "LANG=posix.UTF-8", NULL};
    execve(params[0], params, env);
    printf("exit\n");

    return 0;
}
