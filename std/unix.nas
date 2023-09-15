# unix.nas
# 2023 by ValKmjolnir

var _S_IFDIR = 0x4000;
var _S_IFREG = 0x8000;

var pipe = func() {
    return __pipe;
}

var fork = func() {
    return __fork;
}

var dup2 = func(fd0, fd1) {
    die("not supported yet");
}

var exec = func(filename, argv, envp) {
    die("not supported yet");
}

var waitpid = func(pid, nohang = 0) {
    return __waitpid;
}

var isdir = func(path) {
    return !!bits.u32_and(io.stat(path)[2], _S_IFDIR);
}

var isfile = func(path) {
    return !!bits.u32_and(io.stat(path)[2], _S_IFREG);
}

var opendir = func(path) {
    return __opendir;
}

var readdir = func(handle) {
    return __readdir;
}

var closedir = func(handle) {
    return __closedir;
}

var time = func() {
    return systime();
}

var sleep = func(secs) {
    return __sleep(secs);
}

var chdir = func(path) {
    return __chdir(path);
}

var environ = func() {
    return __environ();
}

var getcwd = func() {
    return __getcwd();
}

var getenv = func(envvar) {
    return __getenv(envvar);
}

var getpath = func() {
    return split(os.platform()=="windows"? ";":":", unix.getenv("PATH"));
}
