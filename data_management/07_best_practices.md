
---

⬅️ [Previous: Data recovery and long-term storage](./06_data_recovery_long_term_storage.md)

## Best Practices for Data Management

### General

- Remove/delete data you no longer use.  Your advisor will thank you.
- When you are getting ready to graduate (perhaps a couple of months hence),
  meet with your advisor and go over your directories and files.
- Organize data by directories and other logical information (e.g., by year).
  - Will aid you in managing your data. 
- Put README.txt files in directories to explain their content.
- For large (public) datasets, contact ARC to see whether it is appropriate to put
  the data in `/common` rather than in your project space.

### File Systems

- File storage alternatives:
  - Your allocation in `/home/<user_name>` is quite small and not really suitable for
    your research work.
  - For longer-term file storage, use `/projects/<advisors-arc-project-name>`.
  - For faster I/O (input/output) for I/O intensive applications, consider putting your
    data in `/scratch/<user_name>`.
    - You can move data between `/projects` and `/scratch` as needed.
  - For even faster I/O, you can use TMPDIR storage ****
- _From workshop on data sharing and transfer_ ...
  - Archive data files that you are not using regularly but that you must preserve.
  - Can `tar` collections of files into one file (to save inode meta data per file).
  - Can compress files (e.g., using _xz_, etc.) to reduce your footprint on your advisor's storage.


### Permissions

- Use default file and directory permissions when possible.
  - Will ensure cooperation between you and your advisor.
- In thinking about expanding your permissions to enable others to see and 
  modify your files, realize that you provide access to should be
  based on "need to know."

### Umask

- You can change your umask to achieve particular default permissions on files and
  directories.
- However, you should have a compelling reason to do this, which will nullify the
  default system-wide default permissions.
- Contact ARC with questions.


### File Ownership

- The individual owning a file is set as the person creating the file.
- Group ownership is the project "group" whose storage you are using.
  - This ensures that your advisor can access files and directories
    for work done on their projects. 

### Data Recovery

- ARC does not back up data on the clusters.  This is your responsibility.
- ARC does create snapshots on some data on an "exponential backoff" basis.
  - This is a best-effort activity of ARC.
  - This is an emergency contingency and should not be considered part of
    a data backup/management plan. 

### Long-Term Storage

- ARC has long-term storage available, but it costs money (on a monthly basis).
- The data backup operation is involved and hence is not amenable to use with
  data that still has to be accessed or a more frequent basis than once per year.





---

⬅️ [Previous: Data recovery and long-term storage](./06_data_recovery_long_term_storage.md)
