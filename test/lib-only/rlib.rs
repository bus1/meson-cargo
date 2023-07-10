//! rlib - Internal Rust Library
//!
//! A simple rust library that exposes a C API to allow calling it
//! from C code. A trivial function that simply adds 71 to its input
//! is exposed.

#[export_name = "rlib_add71"]
pub extern "C" fn add71(v: u32) -> u32 {
    return v + 71;
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add71() {
        assert_eq!(add71(0), 71);
    }
}
