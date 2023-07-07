// r-testlib
//
// Rust sources of Testlib.

use bytes::Buf;

#[export_name = "rtestlib_add71"]
pub extern "C" fn add71(v: u32) -> u32 {
    // Use bytes::Buf to test cargo dependencies
    let mut buf: &[u8] = &[71u8];
    v + (buf.get_u8() as u32)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add71() {
        assert_eq!(add71(0), 71);
    }
}
