/* UPGRADE FROM 2.0 */
/* pt_comments */
EXEC sp_rename 'pt_comments.[comment]', 'commentText', 'COLUMN'
GO