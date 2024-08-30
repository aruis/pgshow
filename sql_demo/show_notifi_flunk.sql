CREATE FUNCTION public.check_score() RETURNS trigger
    LANGUAGE plpgsql
AS
$$
declare
    result varchar;
BEGIN
    if new.n_score < 60 then
        select row_to_json(new)::varchar into result;
        perform pg_notify('flunk', result);
    end if;
    return new;
END;
$$;

CREATE TABLE public.edu_score
(
    id       character varying DEFAULT gen_random_uuid() NOT NULL,
    v_lesson character varying,
    n_score  numeric,
    v_name   character varying
);

ALTER TABLE ONLY public.edu_score
    ADD CONSTRAINT edu_score_pk PRIMARY KEY (id);

CREATE TRIGGER trigger_check_score
    AFTER INSERT
    ON public.edu_score
    FOR EACH ROW
EXECUTE PROCEDURE public.check_score();


truncate table edu_score;

INSERT INTO public.edu_score ( v_lesson, n_score, v_name)
VALUES ('语文', 90, '小明');
INSERT INTO public.edu_score ( v_lesson, n_score, v_name)
VALUES ('语文', 50,'张三');
