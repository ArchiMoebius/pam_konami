const std = @import("std");
const c = @cImport({
    @cInclude("security/pam_appl.h");
    @cInclude("security/pam_modules.h");
    @cInclude("security/pam_ext.h");
    @cInclude("sys/param.h");
    @cInclude("pwd.h");
});

// ↑ ↑ ↓ ↓ ← → ← → b a
const konami = [_]u8{
    0x1b,
    0x5b,
    0x41,
    0x1b,
    0x5b,
    0x41,
    0x1b,
    0x5b,
    0x42,
    0x1b,
    0x5b,
    0x42,
    0x1b,
    0x5b,
    0x44,
    0x1b,
    0x5b,
    0x43,
    0x1b,
    0x5b,
    0x44,
    0x1b,
    0x5b,
    0x43,
    0x62,
    0x61,
};

pub export fn pam_sm_setcred(
    _: ?*c.pam_handle_t,
    _: c_int,
    _: c_int,
    _: [*c][*c]const u8,
) c_int {
    return c.PAM_IGNORE;
}

pub export fn pam_sm_acct_mgmt(
    _: ?*c.pam_handle_t,
    _: c_int,
    _: c_int,
    _: [*c][*c]const u8,
) c_int {
    return c.PAM_IGNORE;
}

pub export fn pam_sm_authenticate(
    pamh: ?*c.pam_handle_t,
    _: c_int,
    _: c_int,
    _: [*]?[*:0]const u8,
) c_int {
    var user: [*:0]u8 = undefined;

    // doesn't mean user exists on system
    if (c.pam_get_user(pamh, @ptrCast(&user), null) != c.PAM_SUCCESS)
        return c.PAM_IGNORE;

    // ensure user exists on the system
    if (c.getpwnam(user) == null)
        return (c.PAM_USER_UNKNOWN);

    var authtok: [*:0]u8 = undefined;
    if (c.pam_get_authtok(pamh, c.PAM_AUTHTOK, @ptrCast(&authtok), null) != c.PAM_SUCCESS)
        return c.PAM_IGNORE;

    if (!std.mem.eql(u8, &konami, std.mem.span(authtok)))
        return c.PAM_AUTH_ERR;

    return c.PAM_SUCCESS;
}
